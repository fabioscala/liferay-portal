<%--
/**
 * Copyright (c) 2000-2013 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/html/portlet/init.jsp" %>

<%@ page import="com.liferay.portal.DuplicateRoleException" %><%@
page import="com.liferay.portal.NoSuchRoleException" %><%@
page import="com.liferay.portal.RequiredRoleException" %><%@
page import="com.liferay.portal.RoleAssignmentException" %><%@
page import="com.liferay.portal.RoleNameException" %><%@
page import="com.liferay.portal.RolePermissionsException" %><%@
page import="com.liferay.portal.kernel.portletdisplaytemplate.BasePortletDisplayTemplateHandler" %><%@
page import="com.liferay.portal.kernel.template.TemplateHandler" %><%@
page import="com.liferay.portal.kernel.template.TemplateHandlerRegistryUtil" %><%@
page import="com.liferay.portal.security.membershippolicy.OrganizationMembershipPolicyUtil" %><%@
page import="com.liferay.portal.security.membershippolicy.RoleMembershipPolicyUtil" %><%@
page import="com.liferay.portal.security.membershippolicy.SiteMembershipPolicyUtil" %><%@
page import="com.liferay.portal.security.permission.PermissionConverterUtil" %><%@
page import="com.liferay.portal.security.permission.comparator.ActionComparator" %><%@
page import="com.liferay.portal.security.permission.comparator.ModelResourceWeightComparator" %><%@
page import="com.liferay.portal.service.permission.RolePermissionUtil" %><%@
page import="com.liferay.portlet.rolesadmin.search.ResourceActionRowChecker" %><%@
page import="com.liferay.portlet.rolesadmin.search.RoleDisplayTerms" %><%@
page import="com.liferay.portlet.rolesadmin.search.RoleSearch" %><%@
page import="com.liferay.portlet.rolesadmin.search.RoleSearchTerms" %><%@
page import="com.liferay.portlet.rolesadmin.util.RolesAdminUtil" %><%@
page import="com.liferay.portlet.usersadmin.search.GroupSearch" %><%@
page import="com.liferay.portlet.usersadmin.search.OrganizationSearch" %><%@
page import="com.liferay.portlet.usersadmin.util.UsersAdminUtil" %>

<%
boolean filterManageableGroups = true;
boolean filterManageableOrganizations = true;
boolean filterManageableRoles = true;

if (permissionChecker.isCompanyAdmin()) {
	filterManageableGroups = false;
	filterManageableOrganizations = false;
}
%>

<%@ include file="/html/portlet/roles_admin/init-ext.jsp" %>

<%!
private String _getActionLabel(PageContext pageContext, ThemeDisplay themeDisplay, String resourceName, String actionId) throws SystemException {
	String actionLabel = null;

	if (actionId.equals(ActionKeys.ACCESS_IN_CONTROL_PANEL)) {
		if (PortalUtil.isControlPanelPortlet(resourceName, PortletCategoryKeys.SITE_ADMINISTRATION, themeDisplay)) {
			actionLabel = LanguageUtil.get(pageContext, "access-in-site-administration");
		}
		else if (PortalUtil.isControlPanelPortlet(resourceName, PortletCategoryKeys.MY, themeDisplay)) {
			actionLabel = LanguageUtil.get(pageContext, "access-in-my-account");
		}
	}

	if (actionLabel == null) {
		actionLabel = ResourceActionsUtil.getAction(pageContext, actionId);
	}

	return actionLabel;
}

private StringBundler _getResourceHtmlId(String resource) {
	StringBundler sb = new StringBundler(2);

	sb.append("resource_");
	sb.append(resource.replace('.', '_'));

	return sb;
}

private boolean _isShowScope(Role role, String curModelResource, String curPortletResource) throws SystemException {
	boolean showScope = true;

	Portlet curPortlet = null;
	String curPortletControlPanelEntryCategory = StringPool.BLANK;

	if (Validator.isNotNull(curPortletResource)) {
		curPortlet = PortletLocalServiceUtil.getPortletById(role.getCompanyId(), curPortletResource);
		curPortletControlPanelEntryCategory = curPortlet.getControlPanelEntryCategory();
	}

	if (curPortletResource.equals(PortletKeys.PORTAL)) {
		showScope = false;
	}
	else if (role.getType() != RoleConstants.TYPE_REGULAR) {
		showScope = false;
	}
	else if (Validator.isNotNull(curPortletControlPanelEntryCategory) && !curPortletControlPanelEntryCategory.startsWith(PortletCategoryKeys.SITE_ADMINISTRATION)) {
		showScope = false;
	}

	if (Validator.isNotNull(curModelResource) && curModelResource.equals(Group.class.getName())) {
		showScope = true;
	}

	return showScope;
}
%>