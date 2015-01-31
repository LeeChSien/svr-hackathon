class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_default_ng_app

  def set_default_ng_app
    @ng_app = 'defaultApp'
  end

  def set_ng_app(ng_app)
    @ng_app = ng_app
  end

  # for Devise
  def after_sign_in_path_for(resource)
    dishes_url
  end

  def ws_cluster_infos
    memcached_host = ChatSetting.instance.memcached_host
    ws_cluster = ChatSetting.instance.ws_cluster

    dalli = Dalli::Client.new(memcached_host)
    ws_cluster.map do |hostname|
      dalli.get("#{hostname}-info")
    end
  end

  def shortest_first_of_ws_cluster
    cluster = ws_cluster_infos
    host_candidate = cluster[0]
    cluster.each { |host| host_candidate = host if host_candidate[:connections] > host[:connections] }

    return host_candidate[:hostname].include?('localhost') ?
    host_candidate.merge!(url: 'localhost:5000') : host_candidate.merge!(url: "#{host_candidate[:hostname]}.herokuapp.com")
  end
end
