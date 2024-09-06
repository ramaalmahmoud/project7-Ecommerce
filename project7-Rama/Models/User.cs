﻿using System;
using System.Collections.Generic;

namespace project7_Rama.Models;

public partial class User
{
    public int UserId { get; set; }

    public string? FirstName { get; set; }

    public string? LastName { get; set; }

    public string? Email { get; set; }

    public string? Password { get; set; }

    public byte[]? PasswordHash { get; set; }

    public byte[]? PasswordSalt { get; set; }

    public string? Phone { get; set; }

    public string? ProfileImage { get; set; }

    public int? Points { get; set; }

    public string? UserType { get; set; }

    public string? Uid { get; set; }

    public virtual ICollection<Cart> Carts { get; set; } = new List<Cart>();

    public virtual ICollection<Comment> Comments { get; set; } = new List<Comment>();

    public virtual ICollection<Logger> Loggers { get; set; } = new List<Logger>();

    public virtual ICollection<Order> Orders { get; set; } = new List<Order>();

    public virtual ICollection<UserAddress> UserAddresses { get; set; } = new List<UserAddress>();

    public virtual ICollection<UserRole> UserRoles { get; set; } = new List<UserRole>();

    public virtual ICollection<UserVoucherUsage> UserVoucherUsages { get; set; } = new List<UserVoucherUsage>();
}
