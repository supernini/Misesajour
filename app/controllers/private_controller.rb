class PrivateController < ApplicationController
  layout 'private'

  def dashboard
    if !current_user.fee.is_a?(Integer)
      if request.subdomains.first=='en'
        redirect_to pricing_en_path
      else
        redirect_to pricing_fr_path
      end

    elsif current_user.fee and !current_user.payed
      redirect_to 'https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=B5M424AT72V4N' if current_user.fee==0
      redirect_to 'https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=6KKA3LBCQTJPW' if current_user.fee==1
      redirect_to 'https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=GQM5698NATW72' if current_user.fee==2
    else
      @rss_twitts = RssTwitt.includes(:rss_provider).where('NOT ISNULL(rss_twitts.send_at)').where(['rss_providers.user_id=?', current_user.id]).order('send_at DESC').limit(3)
      render :layout => false if params[:src]=='ajax'
    end
  end

  def paypal_ok
    redirect dashboard_url
  end

  def paypal_failed

  end
end
