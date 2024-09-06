using System;
using System.Collections.Generic;

namespace project7_Rama.Models;

public partial class Cart
{
    public int CartId { get; set; }

    public int? UserId { get; set; }

    public decimal? TotalAmount { get; set; }

    public virtual ICollection<CartItem> CartItems { get; set; } = new List<CartItem>();

    public virtual User? User { get; set; }
}
