<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="*/pred">pred:	<xsl:value-of select="."/></xsl:template>
	<xsl:template match="*/spred">spred:	<xsl:value-of select="."/></xsl:template>
</xsl:stylesheet>
