 #!/bin/bash    
echo "Starting app.js as www-data user..."
sudo -u www-data forever start -o /home/fzakaria/public/metahypem.com/log/access.log -e /home/fzakaria/public/metahypem.com/log/error.log node ../app.js