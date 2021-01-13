<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs open ser soap"
    version="2.0"
    xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:open="http://www.openuri.org/"
    xmlns:ser="http://eai.mtn.iran/ServiceProvision">
    <xsl:output method="xml" omit-xml-declaration="yes" indent="yes" cdata-section-elements=""/>
    <xsl:param name="user">agl</xsl:param>
    <xsl:param name="pass">agl#1234</xsl:param>
    <xsl:template match="/">
        <SOAP-ENV:Envelope
            xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns:xsd="http://www.w3.org/2001/XMLSchema"
            xmlns:m0="http://xmlns.esf.mtn.com/xsd/Common">
            <SOAP-ENV:Header
                xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
                <wsse:Security>
                    <wsse:UsernameToken>
                        <wsse:Username>
                            <xsl:value-of select="$user"/>
                        </wsse:Username>
                        <wsse:Password>
                            <xsl:value-of select="$pass"/>
                        </wsse:Password>
                    </wsse:UsernameToken>
                </wsse:Security>
            </SOAP-ENV:Header>
            <SOAP-ENV:Body>
                <m:NotifyPaymentRequest
                    xmlns:m="http://xmlns.esf.mtn.com/xsd/NotifyPayment">
                    <m:CommonComponents>
                        <m0:MSISDNNum>
                            <xsl:value-of select="concat('234',//*[local-name()='entityCode']/text())"/>
                        </m0:MSISDNNum>
                        <m0:ProcessingNumber>
                            <xsl:value-of select="//*[local-name()='chronoNumber']/text()"/>
                        </m0:ProcessingNumber>
                        <m0:OrderDateTime>
                            <xsl:value-of select="//*[local-name()='orderDateTime']/text()"/>
                        </m0:OrderDateTime>
                        <m0:OpCoID>NG</m0:OpCoID>
                        <m0:SenderID>AGL</m0:SenderID>
                    </m:CommonComponents>
                    <m:ExtUser>NOTIFS</m:ExtUser>
                    <m:Identification>
                        <m:IdType>LOB</m:IdType>
                        <m:IdValue>Gen</m:IdValue>
                    </m:Identification>
                    <m:Identification>
                        <m:IdType>ReversalStageCode</m:IdType>
                        <m:IdValue>1</m:IdValue>
                    </m:Identification>
                    <m:Identification>
                        <m:IdType>CustID</m:IdType>
                        <m:IdValue>
                            <xsl:value-of select="//*[local-name()='custID']/text()"/>
                        </m:IdValue>
                    </m:Identification>
                    <m:Identification>
                        <m:IdType>ServiceID</m:IdType>
                        <m:IdValue>
                            <xsl:value-of select="concat('234',//*[local-name()='entityCode']/text())"/>
                        </m:IdValue>
                    </m:Identification>
                    <m:Identification>
                        <m:IdType>CustName</m:IdType>
                        <m:IdValue>
                            <xsl:value-of select="//*[local-name()='customerName']/text()"/>
                        </m:IdValue>
                    </m:Identification>
                    <m:Identification>
                        <m:IdType>CustomerType</m:IdType>
                        <m:IdValue>GSM-Postpaid</m:IdValue>
                    </m:Identification>
                    <m:Identification>
                        <m:IdType>SubActionCode</m:IdType>
                        <m:IdValue>
                            <xsl:value-of select="//*[local-name()='subActionCode']/text()"/>
                        </m:IdValue>
                    </m:Identification>
                    <m:Identification>
                        <m:IdType>ExcessAmount</m:IdType>
                        <m:IdValue>
                            <xsl:choose>
                                <xsl:when test="//*[local-name()='excessAmount']/text()!=''">
                                    <xsl:value-of select="(//*[local-name()='excessAmount']/text()/100)"/>
                                </xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>
                        </m:IdValue>
                    </m:Identification>
                    <m:Identification>
                        <m:IdType>OutstandingAmount</m:IdType>
                        <m:IdValue>
                            <xsl:choose>
                                <xsl:when test="//*[local-name()='outStandingAmount']/text()!=''">
                                    <xsl:value-of select="(//*[local-name()='outStandingAmount']/text())/100"/>
                                </xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>
                        </m:IdValue>
                    </m:Identification>
                    <m:Identification>
                        <m:IdType>RequestAmount</m:IdType>
                        <m:IdValue>
                            <xsl:choose>
                                <xsl:when test="//*[local-name()='requestAmount']/text()!=''">
                                    <xsl:value-of select="(//*[local-name()='requestAmount']/text())/100"/>
                                </xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>
                        </m:IdValue>
                    </m:Identification>
                    <m:Identification>
                        <m:IdType>SubActionCode</m:IdType>
                        <m:IdValue>
                            <xsl:value-of select="//*[local-name()='subActionCode']/text()"/>
                        </m:IdValue>
                    </m:Identification>
                    <m:PrefLang>en</m:PrefLang>
                    <m:RequestType>ReversePayment</m:RequestType>
                    <m:PaymentType>InvoicePayment</m:PaymentType>
                    <xsl:choose>
                        <xsl:when test="//*[local-name()='excessAmount']/text()!=''">
                            <m:RecievedPaymentList ActionCode="Bounced">
                                <m:Identification>
                                    <m:IdType>TransactionDesc</m:IdType>
                                    <m:IdValue>
                                        <xsl:value-of select="//*[local-name()='chronoNumber']/text()"/>
                                    </m:IdValue>
                                </m:Identification>
                                <m:Identification>
                                    <m:IdType>ActionCode</m:IdType>
                                    <m:IdValue>Bounced</m:IdValue>
                                </m:Identification>
                                <m:Identification>
                                    <m:IdType>PriceCategory</m:IdType>
                                    <m:IdValue>StandardPayment</m:IdValue>
                                </m:Identification>
                                <m:Identification>
                                    <m:IdType>AccID</m:IdType>
                                    <m:IdValue>
                                        <xsl:value-of select="//*[local-name()='accountId']/text()"/>
                                    </m:IdValue>
                                </m:Identification>
                                <m:Identification>
                                    <m:IdType>ItemCode</m:IdType>
                                    <m:IdValue>EXCESSPAY</m:IdValue>
                                </m:Identification>
                                <m:Identification>
                                    <m:IdType>SerialNumber</m:IdType>
                                    <m:IdValue>*</m:IdValue>
                                </m:Identification>
                                <m:ConfirmationNumber>
                                    <xsl:value-of select="//*[local-name()='chronoNumber']/text()"/>
                                </m:ConfirmationNumber>
                                <m:PaymentMethodCode>Cheque</m:PaymentMethodCode>
                                <m:BankPayment>
                                    <m:Check>
                                        <m:Identification>
                                            <m:IdType>DrawerName</m:IdType>
                                            <m:IdValue>
                                                <xsl:value-of select="//*[local-name()='drawerName']/text()"/>
                                            </m:IdValue>
                                        </m:Identification>
                                        <m:Identification>
                                            <m:IdType>BankName</m:IdType>
                                            <m:IdValue>
                                                <xsl:value-of select="//*[local-name()='bankName']/text()"/>
                                            </m:IdValue>
                                        </m:Identification>
                                        <m:Number>
                                            <xsl:value-of select="//*[local-name()='chequeNumber']/text()"/>
                                        </m:Number>
                                    </m:Check>
                                </m:BankPayment>
                                <m:RequestAmount>
                                    <xsl:value-of select="//*[local-name()='requestAmount']/text()"/>
                                </m:RequestAmount>
                                <m:CurrencyExchange>
                                    <m:SourceCurrencyCode>
                                        <xsl:value-of select="//*[local-name()='currency']/text()"/>
                                    </m:SourceCurrencyCode>
                                </m:CurrencyExchange>
                                <m:AdditionalDetails>
                                    <m:Name>Quantity</m:Name>
                                    <m:Value>1</m:Value>
                                </m:AdditionalDetails>
                            </m:RecievedPaymentList>
                            <m:RecievedPaymentList ActionCode="Bounced">
                                <m:Identification>
                                    <m:IdType>TransactionDesc</m:IdType>
                                    <m:IdValue>
                                        <xsl:value-of select="//*[local-name()='chronoNumber']/text()"/>
                                    </m:IdValue>
                                </m:Identification>
                                <m:Identification>
                                    <m:IdType>ActionCode</m:IdType>
                                    <m:IdValue>Bounced</m:IdValue>
                                </m:Identification>
                                <m:Identification>
                                    <m:IdType>PriceCategory</m:IdType>
                                    <m:IdValue>StandardPayment</m:IdValue>
                                </m:Identification>
                                <m:Identification>
                                    <m:IdType>AccID</m:IdType>
                                    <m:IdValue>
                                        <xsl:value-of select="//*[local-name()='accountId']/text()"/>
                                    </m:IdValue>
                                </m:Identification>
                                <m:Identification>
                                    <m:IdType>ItemCode</m:IdType>
                                    <m:IdValue>EXCESSPAY</m:IdValue>
                                </m:Identification>
                                <m:Identification>
                                    <m:IdType>SerialNumber</m:IdType>
                                    <m:IdValue>*</m:IdValue>
                                </m:Identification>
                                <m:ConfirmationNumber>
                                    <xsl:value-of select="//*[local-name()='chronoNumber']/text()"/>
                                </m:ConfirmationNumber>
                                <m:PaymentMethodCode>Cheque</m:PaymentMethodCode>
                                <m:BankPayment>
                                    <m:Check>
                                        <m:Identification>
                                            <m:IdType>DrawerName</m:IdType>
                                            <m:IdValue>
                                                <xsl:value-of select="//*[local-name()='drawerName']/text()"/>
                                            </m:IdValue>
                                        </m:Identification>
                                        <m:Identification>
                                            <m:IdType>BankName</m:IdType>
                                            <m:IdValue>
                                                <xsl:value-of select="//*[local-name()='bankName']/text()"/>
                                            </m:IdValue>
                                        </m:Identification>
                                        <m:Number>
                                            <xsl:value-of select="//*[local-name()='chequeNumber']/text()"/>
                                        </m:Number>
                                    </m:Check>
                                </m:BankPayment>
                                <m:RequestAmount>
                                    <xsl:value-of select="//*[local-name()='requestAmount']/text()"/>
                                </m:RequestAmount>
                                <m:CurrencyExchange>
                                    <m:SourceCurrencyCode>
                                        <xsl:value-of select="//*[local-name()='currency']/text()"/>
                                    </m:SourceCurrencyCode>
                                </m:CurrencyExchange>
                                <m:AdditionalDetails>
                                    <m:Name>Quantity</m:Name>
                                    <m:Value>1</m:Value>
                                </m:AdditionalDetails>
                            </m:RecievedPaymentList>
                        </xsl:when>
                        <xsl:otherwise></xsl:otherwise>
                    </xsl:choose>
                </m:NotifyPaymentRequest>
            </SOAP-ENV:Body>
        </SOAP-ENV:Envelope>
    </xsl:template>
</xsl:stylesheet> 
