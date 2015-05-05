namespace :email do
  desc "Resets an original user's password and sends them in invitation to our new site"
  task :original_users => :environment do

    sent_to_emails = %w(
      falveya@bellsouth.net
      momoxiaoling@gmail.com
      nora.kurtz@gmail.com
      caseylevinson@gmail.com
      scollins@bronxprep.org
      aheadmerchant@netcourrier.com
      Robinlynne116@aol.com
      Mariarozos@hotmail.com
      kdp2118@tc.columbia.edu
      sh3256@tc.columbia.edu
      rianna.rosen@gmail.com
      solangefingal@gmail.com
      tmla_green@yahoo.com
      mjdickens@hotmail.com
      jcedeno1375@aol.com
      kss2142@tc.columbia.edu
      nyckinderteacher@hotmail.com
      me@jonl.org
      aa1364@hunter.cuny.edu
      marne.meisel@gmail.com
      msvtalavera@gmail.com
      twl2112@tc.edu
      ayemilea@gmail.com
      MeganJ24@gmail.com
      jodisammons@gmail.com
      meahazelton@gmail.com
      hqhuynh90@yahoo.com
      rca2131@tc.columbia.edu
      hanqie86@gmail.com
      SMactas2@schools.nyc.gov
      gaddyporsche@gmail.com
      yangbodu@alum.mit.edu
      aarrozal2@schools.nyc.gov
      maricfer@xlxe.pl
      jz2456@tc.columbia.edu
      kenneyrobinson@gmail.com
      wspagnola@gmail.com
      Corey.marcus.murphy@gmail.com
      veronicaawilliams@gmail.com
      AbbieMCs@Optonline.Net
      thomsen.sabrina@gmail.com
      fellers@schools.nyc.gov
      sylvimak30@yahoo.com
      tamivuong@gmail.com
      Ltrue07@gmail.com
      Irmalelis@gmail.com
      epw22@aol.com
      elizabethpashley@gmail.com
      kbutler@schools.nyc.gov
      misecordia@gmail.com
      stevensonmartin@att.net
      Mlcb1119@aol.com
      ashanti.rimes@gmail.com
      hw2434@tc.columbia.edu
      skeapm@gmail.com
      TPicciano@schools.nyc.gov
      anandrai@si.rr.com
      hymnising@yahoo.com
      schreck7@hotmail.com
      Kerryannrawlins@hotmail.com
      tomasdlbutler@yahoo.com
      steelreign19@yahoo.com
      ctetonis@gmail.com
      Mrslmsantiago@gmail.com
      elliejeanne58@hotmail.com
      sciguy54@verizon.net
      nlynch803@yahoo.com
      hilltia@hotmail.com
      mrdavis368@gmail.com
      yelena.boroda@gmail.com
      Abrasel79@gmail.com
      drrncst@yahoo.com
      rda976@gmail.com
      theanacastro@hotmail.com
      erick.eperez@gmail.com
      woodle107@aol.com
      debra.a.calvo@gmail.com
      gmsotomayor@aol.com
      MsRivera6@aol.com
      msecarman@gmail.com
      LPerez.Khury@gmail.com
      Kimmylu@aol.com
      MGaitan100@yahoo.com
      kristymguzman@gmail.com
      mslortiz4@gmail.com
      ktesun@gmail.com
      mrhiggins01@gmail.com
      winstoncerrosi@gmail.com
      mrkearns2@gmail.com
      Lizzieblueyez@yahoo.com
      martymack@gmail.com
      patriciamagloire@yahoo.com
      roddee123@aol.com
      jsmithh@schools.nyc.gov
      mscindyflores@gmail.com
      Egregorek@gmail.com
      darbykennethl@gmail.com
      hrotga@gmail.com
      rhill@teamschools.org
      R_Tirino@yahoo.com
      sablejoneswalford@gmail.com
      GSchenk156@gmail.com
      hongnhi@gmail.com
      lipkowitz.michael@gmail.com
      gioamias@aol.com
      laura1213x@gmail.com
      seanmoughty@gmail.com
      tomasclasen9@gmail.com
      mammaschwa@gmail.com
      twinter@hsenergytech.org
      jeancpallister@gmail.com
      drosas@teccs-ny.org
      lizzieblueyez@yahoo.com
    )

    # these guys were invited twice!!!
    %w(
      gschenk156@gmail.com
      r_tirino@yahoo.com
      mrslmsantiago@gmail.com
      mariarozos@hotmail.com
      robinlynne116@aol.com
      egregorek@gmail.com
      mgaitan100@yahoo.com
      kimmylu@aol.com
      lperez.khury@gmail.com
      msrivera6@aol.com
      abrasel79@gmail.com
      kerryannrawlins@hotmail.com
      tpicciano@schools.nyc.gov
      mlcb1119@aol.com
      irmalelis@gmail.com
      ltrue07@gmail.com
      abbiemcs@optonline.net
      corey.marcus.murphy@gmail.com
      smactas2@schools.nyc.gov
      meganj24@gmail.com
    )

    cleaned_sent_to_emails = sent_to_emails.map { |email| email.downcase.strip }

    users = User.where(original_user: true)
    # users = User.in(email: ['ajm845@gmail.com', 'natashamarra@gmail.com'])
    sent_count = 0
    not_sent_count = 0
    users.each do |user|
      if cleaned_sent_to_emails.include?(user.email.downcase.strip)
        user.set(sent_original_user_invite: true)

        puts "Already sent!!"
        sent_count += 1
      else
        random_password = User.send(:generate_token, 'encrypted_password').slice(0, 8)
        user.password = random_password
        user.added_password = false
        user.dont_show_add_password_page = false
        user.sent_original_user_invite = true
        user.save

        EpMailer.original_user_password_reset(user, random_password).deliver

        puts "Not Sent."
        not_sent_count += 1
      end
      sleep 2
    end
    puts "sent --->#{sent_count}"
    puts "not sent --->#{not_sent_count}"
  end
end