(setq +mu4e-backend 'offlineimap)
(setq +mu4e-mu4e-mail-path '~/mail)

;; Each path is relative to `+mu4e-mu4e-mail-path'
(set-email-account! "aut"
                    '((mu4e-sent-folder       . "/Sent")
                      (mu4e-drafts-folder     . "/Drafts")
                      (mu4e-trash-folder      . "/Trash")
                      (mu4e-refile-folder     . "/Archive")
                      (smtpmail-smtp-user     . "parham.alvani@aut.ac.ir")
                      (smtpmail-default-smtp-server . "webmail.aut.ac.ir")
                      (smtpmail-smtp-server . "webmail.aut.ac.ir")
                      (smtpmail-smtp-service . 587)
                      (user-mail-address      . "parham.alvani@aut.ac.ir")
                      (mu4e-compose-signature . (concat
                                                 "Parham Alvani\n"
                                                 "Ph.D. Student of Computer Networks Engineering\nAmirkabir University of Technology\n"
                                                 "parham.alvani@gmail.com | parham.alvani@aut.ac.ir\nhttp://1995parham.github.io")))
                    t)

(set-email-account! "secret"
                    '((mu4e-sent-folder       . "/Sent")
                      (mu4e-drafts-folder     . "/Drafts")
                      (mu4e-trash-folder      . "/Trash")
                      (mu4e-refile-folder     . "/Archive")
                      (smtpmail-smtp-user     . "1995parham@hitler.rocks")
                      (smtpmail-smtp-server . "mail.cock.li")
                      (smtpmail-smtp-service . 587)
                      (user-mail-address      . "1995parham@hitler.rocks")
                      (mu4e-compose-signature . (concat
                                                 "Please don't reply to this address\n"
                                                 "This email is solely for fun")))
                    )
