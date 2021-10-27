# This script uses LDLite to extract sample data from the FOLIO demo sites.

# Demo sites
current_release = 'https://folio-juniper-okapi.dev.folio.org/'
latest_snapshot = 'https://folio-snapshot-okapi.dev.folio.org/'
mainz_test = 'https://folio-test.ub.uni-mainz.de/okapi/'


###############################################################################
# Select a demo site here:
selected_site = mainz_test
###############################################################################
# Note that these demo sites are unavailable at certain times in the evening
# (Eastern time) or if a bug is introduced and makes one of them unresponsive.
# At the time of this writing, the "current release" demo site appears to be
# more stable than the "latest snapshot" site.  For information about the
# status of the demo sites, please see the #hosted-reference-envs channel in
# the FOLIO Slack organization.  For general information about FOLIO demo
# sites, see the "Demo Sites" section of the FOLIO Wiki at:
# https://wiki.folio.org
###############################################################################

import traceback
import ldlite
ld = ldlite.LDLite()
ld.connect_okapi(url=selected_site, tenant='ubmz', user='adminC', password='xxxx')

#db = ld.connect_db(filename='ldlite.db')
# For PostgreSQL, use connect_db_postgresql() instead of connect_db():
db = ld.connect_db_postgresql(dsn='dbname=ldlite_01 host=localhost user=ldlite password=ldlite')

queries = [
('folio_agreements.subscription_agreement', '/erm/sas', 'cql.allRecords=1 sortby id'),
#('folio_agreements.publicLookup', '/erm/sas/publicLookup', 'cql.allRecords=1 sortby id'),
('folio_agreements.entitlement', '/erm/entitlements', 'cql.allRecords=1 sortby id'),
('folio_agreements.files', '/erm/files', 'cql.allRecords=1 sortby id'),
('folio_agreements.contacts', '/erm/contacts', 'cql.allRecords=1 sortby id'),
('folio_agreements.package', '/erm/packages', 'cql.allRecords=1 sortby id'),
('folio_agreements.job', '/erm/jobs', 'cql.allRecords=1 sortby id'),
('folio_agreements.refdata_value', '/erm/refdata', 'cql.allRecords=1 sortby id'),
('folio_agreements.kbs', '/erm/kbs', 'cql.allRecords=1 sortby id'),
('folio_agreements.erm_resource', '/erm/resource', 'cql.allRecords=1 sortby id'),
('folio_agreements.title', '/erm/titles', 'cql.allRecords=1 sortby id'),
('folio_agreements.titles_entitled', '/erm/titles/entitled', 'cql.allRecords=1 sortby id'),
('folio_agreements.package_content_item', '/erm/pci', 'cql.allRecords=1 sortby id'),
('folio_agreements.platform', '/erm/platforms', 'cql.allRecords=1 sortby id'),
('folio_agreements.platform_title_instance', '/erm/pti', 'cql.allRecords=1 sortby id'),
('folio_agreements.custom_property', '/erm/custprops', 'cql.allRecords=1 sortby id'),
# ('folio_agreements.sts', '/erm/sts', 'cql.allRecords=1 sortby id'),
('folio_agreements.subscription_agreement_licences', '/erm/sas/linkedLicenses', 'cql.allRecords=1 sortby id'),
    ]

tables = []
for q in queries:
    try:
        if len(q) == 4:
            t = ld.query(table=q[0], path=q[1], query=q[2], json_depth=[3])
        else:
            t = ld.query(table=q[0], path=q[1], query=q[2])
    except Exception as e:
        traceback.print_exception(type(e), e, e.__traceback__)
    tables += t
print()
print('Tables:')
for t in tables:
    print(t)
print('('+str(len(tables))+' tables)')


