<#include "../init.ftl">

<div class="yui3-aui-field-wrapper-content lfr-forms-field-wrapper">
	<@aui.input label=label name=namespacedFieldName type="checkbox" value=fieldValue!field.predefinedValue />

	${field.children}
</div>