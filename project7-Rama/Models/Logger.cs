using System;
using System.Collections.Generic;

namespace project7_Rama.Models;

public partial class Logger
{
    public int LogId { get; set; }

    public int? UserId { get; set; }

    public string? LogMessage { get; set; }

    public string? LogLevel { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual User? User { get; set; }
}
