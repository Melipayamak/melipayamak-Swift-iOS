# melipayamak Swift iOS

<div dir='rtl'>

### معرفی وب سرویس ملی پیامک
ملی پیامک یک وب سرویس کامل برای ارسال و دریافت پیامک و پیامک صوتی و مدیریت کامل خدمات دیگر است که براحتی میتوانید از آن استفاده کنید.

<hr>

### نصب

<p>قبل از نصب نیاز به ثبت نام در سایت ملی پیامک دارید.</p>

[**ثبت نام به همراه دریافت 200 پیامک هدیه جهت تست وبسرویس**](http://www.melipayamak.com/)

</div>

<div dir='rtl'>
  
#### نحوه استفاده

نمونه کد برای ارسال پیامک

</div>


```js
let username: String = "username"
let password: String = "password"
let from: String = "5000..."
var to: String = "09123456789"
var text: String = "تست وب سرویس ملی پیامک"
var isFlash: Bool = false
var soapClient = SoapClient(username, password)
soapClient.SendSimpleSMS2(to, from, text, isFlash)
//یا برای ارسال به مجموعه ای از مخاطبین
soapClient.SendSimpleSMS(arrayOf(to), from, text, isFlash)
```

<div dir='rtl'>

از آنجا که وب سرویس ملی پیامک تنها محدود به ارسال پیامک نیست شما از طریق زیر میتوانید به وب سرویس ها دسترسی کامل داشته باشید:
</div>

```js
// وب سرویس پیامک
val restClient = RestClient(username, password)
val soapClient = SoapClient(username, password)
```

<div dir='rtl'>
  
#### تفاوت های وب سرویس پیامک rest و soap

از آنجا که ملی پیامک وب سرویس کاملی رو در اختیار توسعه دهندگان میگزارد برای راحتی کار با وب سرویس پیامک علاوه بر وب سرویس اصلی soap وب سرویس rest رو هم در اختیار توسعه دهندگان گزاشته شده تا راحتتر بتوانند با وب سرویس کار کنند. تفاوت اصلی این دو در تعداد متد هاییست که میتوانید با آن کار کنید. برای کار های پایه میتوان از وب سرویس rest استفاده کرد برای دسترسی بیشتر و استفاده پیشرفته تر نیز باید از وب سرویس باید از وب سرویس soap استفاده کرد. جهت مطالعه بیشتر وب سرویس ها به قسمت وب سرویس پنل خود مراجعه کنید.

<hr/>


###  اطلاعات بیشتر

برای مطالعه بیشتر و دریافت راهنمای وب سرویس ها و آشنایی با پارامتر های ورودی و خروجی وب سرویس به صفحه معرفی
[وب سرویس ملی پیامک](https://github.com/Melipayamak/Webservices)
مراجعه نمایید .


<hr/>

</div>


<div dir='rtl'>

### وب سرویس پیامک

متدهای وب سرویس:

</div>

#### ارسال

```js
restClient.Send(to, from, text, isFlash)
soapClient.SendSimpleSMS(arrayOf(to), from, text, isFlash)
```
<div dir='rtl'>
  در آرگومان سوم روش soap میتوانید از هر تعداد مخاطب به عنوان آرایه استفاده کنید
</div>

#### دریافت وضعیت ارسال
```js
restClient.GetDelivery(recId)
soapClient.GetDelivery(recId)
soapClient.GetDeliveries(arrayOf(recIds))
```

#### لیست پیامک ها

```js
restClient.GetMessages(location, index, count, from);
soapClient.getMessages(location, from, index, count);
// جهت دریافت به صورت رشته ای
soapClient.GetMessagesByDate(location, from, index, count, dateFrom, dateTo);
//جهت دریافت بر اساس تاریخ
soapClient.GetUsersMessagesByDate(location, from, index, count, dateFrom, dateTo);
// جهت دریافت پیام های کاربران بر اساس تاریخ 
```

#### موجودی
```js
restClient.GetCredit();
soapClient.GetCredit();
```

#### تعرفه پایه / دریافت قیمت قبل از ارسال
```js
restClient.GetBasePrice();
soapClient.GetSmsPrice(irancellCount, mtnCount, from, text);
```
#### لیست شماره اختصاصی
```js
soapClient.GetUserNumbers();
```

#### بررسی تعداد پیامک های دریافتی
```js
soapClient.GetInboxCount(isRead);
//پیش فرض خوانده نشده 
```

#### ارسال پیامک پیشرفته
```js
soapClient.SendSms(arrayOf(to), from, text, isflash, udh, arrayOf(recId), arrayOf(status));
```

#### مشاهده مشخصات پیام
```js
soapClient.GetMessagesReceptions(msgId, fromRows);
```


#### حذف پیام دریافتی
```js
soapClient.RemoveMessages2(location, msgIds);
```


#### ارسال زماندار
```js
soapClient.AddSchedule(to, from, text, isflash, scheduleDateTime, period);
```

#### ارسال زماندار متناظر
```js
soapClient.AddMultipleSchedule(arrayOf(to), from, arrayOf(text), isflash, arrayOf(scheduleDateTime), period);
```


#### ارسال سررسید
```js
soapClient.AddNewUsance(to, from, text, isflash, scheduleStartDateTime, countRepeat, scheduleEndDateTime, periodType);
```

#### مشاهده وضعیت ارسال زماندار
```js
soapClient.GetScheduleStatus(schId);
```

#### حذف پیامک زماندار
```js
soapClient.RemoveSchedule(schId);
```


####  ارسال پیامک همراه با تماس صوتی
```js
soapClient.SendSMSWithSpeechText(smsBody, speechBody, from, to);
```

####  ارسال پیامک همراه با تماس صوتی به صورت زمانبندی
```js
soapClient.SendSMSWithSpeechTextBySchduleDate(smsBody, speechBody, from, to, scheduleDate);
```

####  دریافت وضعیت پیامک همراه با تماس صوتی 
```js
soapClient.GetSendSMSWithSpeechTextStatus(recId);
```
<div dir='rtl'>
  
### وب سرویس ارسال انبوه/منطقه ای

</div>

#### دریافت شناسه شاخه های بانک شماره
```js
soapClient.GetBranchs(owner);
```


#### اضافه کردن یک بانک شماره جدید
```js
soapClient.AddBranch(branchName, owner);
```

#### اضافه کردن شماره به بانک
```js
soapClient.AddNumber(branchId, arrayOf(mobileNumbers));
```

#### حذف یک بانک
```js
soapClient.RemoveBranch(branchId);
```

#### ارسال انبوه از طریق بانک
```js
soapClient.AddBulk(from, branch, bulkType, title, message, rangeFrom, rangeTo, DateToSend, requestCount, rowFrom);
```

#### تعداد شماره های موجود
```js
soapClient.GetBulkCount(branch, rangeFrom, rangeTo);
```

#### گزارش گیری از ارسال انبوه
```js
soapClient.GetBulkReceptions(bulkId, fromRows);
```


#### تعیین وضعیت ارسال 
```js
soapClient.GetBulkStatus(bulkId, sent, failed, status);
```

#### تعداد ارسال های امروز
```js
soapClient.GetTodaySent();
```

#### تعداد ارسال های کل

```js
soapClient.GetTotalSent();
```

#### حذف ارسال منطقه ای
```js
soapClient.RemoveBulk(bulkId);
```

#### ارسال متناظر
```js
soapClient.SendMultipleSMS(arrayOf(to), from, arrayOf(text), isflash, udh, arrayOf(recId), status);
```

#### نمایش دهنده وضعیت گزارش گیری

```js
soapClient.UpdateBulkDelivery(bulkId);
```
<div dir='rtl'>
  
### وب سرویس تیکت

</div>

#### ثبت تیکت جدید
```js
soapClient.AddTicket(title, content, aletWithSms);
```

#### جستجو و دریافت تیکت ها

```js
soapClient.GetReceivedTickets(ticketOwner, ticketType, keyword);
```

#### دریافت تعداد تیکت های کاربران
```js
soapClient.GetReceivedTicketsCount(ticketType);
```

#### دریافت تیکت های ارسال شده
```js
soapClient.GetSentTickets(ticketOwner, ticketType, keyword);
```

#### دریافت تعداد تیکت های ارسال شده
```js
soapClient.GetSentTicketsCount(ticketType);
```


#### پاسخگویی به تیکت
```js
soapClient.ResponseTicket(ticketId, type, content, alertWithSms);
```
<div dir='rtl'>
  
### وب سرویس دفترچه تلفن

</div>

#### اضافه کردن گروه جدید
```js
soapClient.AddGroup(groupName, Descriptions, showToChilds);
```

#### اضافه کردن کاربر جدید
```js
soapClient.AddContact(options);

```

#### بررسی موجود بودن شماره در دفترچه تلفن
```js
soapClient.CheckMobileExistInContact(mobileNumber);
```

#### دریافت اطلاعات دفترچه تلفن
```js
soapClient.GetContacts(groupId, keyword, count);
```
#### دریافت گروه ها
```js
soapClient.GetGroups();
```
#### ویرایش مخاطب
```js
soapClient.ChangeContact(options);
```

#### حذف مخاطب
```js
soapClient.RemoveContact(mobilenumber);
```
#### دریافت اطلاعات مناسبت های فرد
```js
soapClient.GetContactEvents(contactId);
```

<div dir='rtl'>

### وب سرویس کاربران

</div>

#### ثبت فیش واریزی
```js
soapClient.AddPayment(options);
```

#### اضافه کردن کاربر جدید در سامانه
```js
soapClient.AddUser(options);

```

#### اضافه کردن کاربر جدید در سامانه(کامل)
```js
soapClient.AddUserComplete(options);
```

#### اضافه کردن کاربر جدید در سامانه(WithLocation)
```js
soapClient.AddUserWithLocation(options);
```
#### بدست آوردن ID کاربر
```js
soapClient.AuthenticateUser();
```
#### تغییر اعتبار
```js
soapClient.ChangeUserCredit(amount, description, targetUsername, GetTax);
```

#### فراموشی رمز عبور
```js
soapClient.ForgotPassword(mobileNumber, emailAddress, targetUsername);
```
#### دریافت تعرفه پایه کاربر
```js
soapClient.GetUserBasePrice(targetUsername);
```

#### دریافت اعتبار کاربر
```js
soapClient.GetUserCredit(targetUsername);
```

#### دریافت مشخصات کاربر
```js
soapClient.GetUserDetails(targetUsername);
```

#### دریافت شماره های کاربر
```js
soapClient.GetUserNumbers();
```

#### دریافت تراکنش های کاربر
```js
soapClient.GetUserTransactions(targetUsername, creditType, dateFrom, dateTo, keyword);
```

#### دریافت اطلاعات  کاربران
```js
soapClient.GetUsers();
```


#### دریافت اطلاعات  فیلترینگ
```js
soapClient.HasFilter(text);
```


####  حذف کاربر
```js
soapClient.RemoveUser(targetUsername);
```


#### مشاهده استان ها
```js
soapClient.GetProvinces();
```

#### مشاهده کد شهرستان 
```js
soapClient.GetCities(provinceId);
```


#### مشاهده تاریخ انقضای کاربر 
```js
soapClient.GetExpireDate();
```
