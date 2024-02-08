﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Operations.master" AutoEventWireup="true" CodeFile="gheeclosing.aspx.cs" Inherits="gheeclosing" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            fillgheeproductsales();
            var today = new Date();
            var dd = today.getDate();
            var mm = today.getMonth() + 1; //January is 0!
            var yyyy = today.getFullYear();
            if (dd < 10) {
                dd = '0' + dd
            }
            if (mm < 10) {
                mm = '0' + mm
            }
            var hrs = today.getHours();
            var mnts = today.getMinutes();
            $('#txt_sdate').val(yyyy + '-' + mm + '-' + dd + 'T' + hrs + ':' + mnts);
        });
        function callHandler(d, s, e) {
            $.ajax({
                url: 'FleetManagementHandler.axd',
                data: d,
                type: 'GET',
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                async: true,
                cache: true,
                success: s,
                error: e
            });
        }
        function CallHandlerUsingJson(d, s, e) {
            d = JSON.stringify(d);
            d = d.replace(/&/g, '\uFF06');
            d = d.replace(/#/g, '\uFF03');
            d = d.replace(/\+/g, '\uFF0B');
            d = d.replace(/\=/g, '\uFF1D');
            $.ajax({
                type: "GET",
                url: "FleetManagementHandler.axd?json=",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data: d,
                async: true,
                cache: true,
                success: s,
                error: e
            });
        }
        function save_ghee_closing_click() {
        }
        function fillgheeproductsales() {
            var data = { 'op': 'get_product_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        var results = '<div    style="overflow:auto;"><table id="table_sales_wise_details" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
                        results += '<thead><tr><th scope="col">Sno</th><th scope="col">Product Name</th><th scope="col">Quantity</th></tr></thead></tbody>';
                        for (var i = 0; i < msg.length; i++) {
                            if (msg[i].departmentid == "3") {
                                results += '<tr>';
                                results += '<th><span id="Span1" style="font-size: 12px; font-weight: bold; color: #0252aa;">' + msg[i].sno + '</span></th>';
                                results += '<th><span id="txt_productname" style="font-size: 12px; font-weight: bold; color: #0252aa;">' + msg[i].productname + '</span></th>';
                                results += '<td><input id="txt_sales" class="form-control" value="' + msg[i].quantity + '" type="number" name="vendorcode"placeholder="Enter qty"></td>';
                                results += '<td style="display:none" class="8"><input id="hdn_productid" class="form-control" type="number" name="vendorcode" value="' + msg[i].productid + '"></td></tr>';
                            }
                        }
                        results += '</table></div>';
                        $("#divsales").html(results);
                    }
                    else {
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function save_ghee_sales_click() {
            var remarks = document.getElementById('txt_sRemarks').value;
            var date = document.getElementById('txt_sdate').value;
            var btnvalue = document.getElementById('btnsales').innerHTML;
            var sno = document.getElementById('lbl_ssno').value;
            var rows = $("#table_sales_wise_details tr:gt(0)");
            var ghee_closing_details = new Array();
            $(rows).each(function (i, obj) {
                if ($(this).find('#txt_dispatchqty').val() != "") {
                    ghee_closing_details.push({ productid: $(this).find('#hdn_productid').val(), quantity: $(this).find('#txt_sales').val() });
                }
            });
            if (ghee_closing_details.length == 0) {
                alert("Please enter opening balance");
                return false;
            }
            var confi = confirm("Do you want to Save Transaction ?");
            if (confi) {
                var data = { 'op': 'save_ghee_closing_click', 'ghee_closing_details': ghee_closing_details, 'date': date, 'remarks': remarks, 'btnvalue': btnvalue, 'sno': sno };
                var s = function (msg) {
                    if (msg) {
                        if (msg.length > 0) {
                            alert(msg);
                            //pclearvalues();
                        }
                    }
                    else {
                    }
                };
                var e = function (x, h, e) {
                };
                $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
                CallHandlerUsingJson(data, s, e);
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
           Ghee Closing Details<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#">Ghee Closing Details</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-body">
                <div id="divproductionsales">
                    <div class="box box-danger">
                        <div class="box-header with-border">
                            <h3 class="box-title">
                                <i style="padding-right: 5px;" class="fa fa-cog"></i>Ghee Closing Details</h3>
                        </div>
                    </div>
                    <div style="padding-left: 40%;">
                        <table>
                            <tr>
                                <label>
                                    Date<span style="color: red;">*</span></label>
                                <input id="txt_sdate" class="form-control" type="datetime-local" name="vendorcode"
                                    style="width: 200px;" placeholder="Enter Date">
                            </tr>
                        </table>
                    </div>
                    <div id="divsales">
                    </div>
                    <div style="padding-left: 24%;">
                        <table align="center">
                            <tr hidden>
                                <td>
                                    <label id="lbl_ssno">
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>
                                        Remarks</label>
                                    <textarea rows="3" cols="45" id="txt_sRemarks" class="form-control" maxlength="200"
                                        placeholder="Enter Remarks"></textarea>
                                </td>
                            </tr>
                            <%--<tr>
                                <td>
                                    <input id='btnsales' type="button" class="btn btn-success" name="submit" value='Save'
                                        onclick="save_ghee_sales_click()" />
                                    <input id='btnclear' type="button" class="btn btn-danger" name="Clear" value='Clear'
                                        onclick="salesclearvalues()" />
                                </td>
                            </tr>--%>
                        </table>
                         <div  style="padding-left: 25%;padding-top: 2%;">
                        <table>
                        <tr>
                        <td>
                            <div class="input-group">
                                <div class="input-group-addon">
                                <span class="glyphicon glyphicon-ok" id="btnsales1" onclick="save_ghee_sales_click()"></span><span id="btnsales" onclick="save_ghee_sales_click()">Save</span>
                            </div>
                            </div>
                            </td>
                            <td style="width:10px;"></td>
                            <td>
                                <div class="input-group">
                                <div class="input-group-close">
                                <span class="glyphicon glyphicon-remove" id='btnclear1' onclick="salesclearvalues()"></span><span id='btnclear' onclick="salesclearvalues()">Clear</span>
                            </div>
                            </div>
                            </td>
                            </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>

