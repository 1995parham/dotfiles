(define-configuration nyxt/proxy-mode:proxy-mode
                      ((proxy (make-instance 'proxy
                                             :url (quri:uri "socks5://localhost:1086")
                                             :allowlist '("localhost" "localhost:8080")
                                             :proxied-downloads-p t))))

(define-configuration buffer
                      ((default-modes (append '(auto-mode vi-normal-mode) %slot-default%))))
