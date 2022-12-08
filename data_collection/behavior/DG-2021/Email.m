function Email(Address,subject,content,file)
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
MyAddress = 'sunlab111@163.com';
Password = 'UBGQFXWRRZQHOCFM';
setpref('Internet','SMTP_Server','smtp.163.com');
setpref('Internet','E_mail',MyAddress);
setpref('Internet','SMTP_Username',MyAddress);
setpref('Internet','SMTP_Password',Password);
if nargin == 2
    sendmail(Address,subject);
elseif nargin == 3
    sendmail(Address,subject,content);
    elseif nargin == 4
    sendmail(Address,subject,content,file);
elseif nargin>4||nargin<2
    error( 'Input Error' );
end
end