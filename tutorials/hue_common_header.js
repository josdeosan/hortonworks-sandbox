/*
# Licensed to Hortonworks, Inc. under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  Hortonworks, Inc. licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
*/
// auto login and anonymous users

function removeCookie() {
    document.cookie = "added=;path=/;expires=Thu, 01-Jan-1970 00:00:01 GMT";
}

function setCookie() {
    document.cookie = "added=1;path=/;";
}

function handleAutoLogin() {
    // change drop-down menu for anonymous user
    username =  document.getElementById("usernameDropdown").getElementsByTagName("a")[0].text.trim();
    var isAnonymous = username == "AnonymousUser";
    if (isAnonymous) {
        var profileRef = document.getElementsByClassName("userProfile")[0];
        profileRef.text = "Create new user";
        profileRef.innerText = "Create new user";
        profileRef.href="/useradmin/users/new";
    }

    var isAddingUser = document.location.pathname=="/useradmin/users/new";
    if (isAddingUser && isAnonymous) {
        document.getElementById("editForm").onsubmit = function(){
            setCookie();
            return true;
        }

        if ((document.getElementsByClassName("errorlist").length) > 0) {
            // remove cookie (error while creating)
            removeCookie();
        }
    }

    isAddedSuccessfully = $.cookie("added") !== null;
    if (isAddedSuccessfully) {
        removeCookie();
        setTimeout(function(){window.location = "/accounts/logout/"}, 100);
    }

}


if(window.top != window) {
    var l = document.location;
    document.createElement("img").src = l.protocol + "//" + l.hostname +
                                        ":8888" + "/sync/?loc=" + 
    escape(document.location.href);
}
