# Get current user context
# v1.2  10/24/2011
# Created by Jason Himmelstein
# http://www.sharepointlonghorn.com
# @jasehimm

[Security.Principal.WindowsIdentity]::GetCurrent().Name