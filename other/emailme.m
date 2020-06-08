% Call this function to send an email with a given subject and message to
% my gmail account from my Oxford account

function [] = emailme(subject, message)
%EMAILME(subject, message)
%  subject: Filename for saving
setpref('Internet','E_mail','bras2756@gmail.com');
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username','bras2756');
setpref('Internet','SMTP_Password','nA84Rz@917u9');

props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', ...
                  'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

sendmail('david.j.hansford@gmail.com', subject, message);
end