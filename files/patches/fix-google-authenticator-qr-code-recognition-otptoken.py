--- a/usr/lib/python2.7/site-packages/ipaserver/plugins/otptoken.py
+++ b/usr/lib/python2.7/site-packages/ipaserver/plugins/otptoken.py
@@ -228,10 +228,10 @@
             cli_name='algo',
             label=_('Algorithm'),
             doc=_('Token hash algorithm'),
-            default=u'sha1',
+            default=u'SHA1',
             autofill=True,
             flags=('no_update'),
-            values=(u'sha1', u'sha256', u'sha384', u'sha512'),
+            values=(u'SHA1', u'SHA256', u'SHA384', u'SHA512'),
         ),
         IntEnum('ipatokenotpdigits?',
             cli_name='digits',
