extension BAAUser{
    var email:String{
        get{
            if let email = visibleByTheUser["email"] as? String{
                return email
            }
            return ""
        }
        set{
            visibleByTheUser["email"] = newValue
        }
        
    }
    var name:String{
        return firstName + " " + lastName
    }
    var firstName:String{
        get{
            if let firstName = visibleByTheUser["firstName"] as? String{
                return firstName
            }
            return ""
        }
        set{
            visibleByTheUser["firstName"] = newValue
        }
        
    }
    var lastName:String{
        get{
            if let lastName = visibleByTheUser["lastName"] as? String{
                return lastName
            }
            return ""
        }
        set{
            visibleByTheUser["lastName"] = newValue
        }
    }
    var profilePicture:String{
        get{
            if let profilePicture = visibleByTheUser["profilePicture"] as? String{
                return profilePicture
            }
            return ""
        }
        set{
            visibleByTheUser["profilePicture"] = newValue
        }
    }
    
}

