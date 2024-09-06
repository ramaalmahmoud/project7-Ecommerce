using System;
using System.Collections.Generic;

namespace project7_Rama.Models;

public partial class Feedback
{
    public int FeedbackId { get; set; }

    public string? Name { get; set; }

    public string? Email { get; set; }

    public string? Subject { get; set; }

    public string? Message { get; set; }

    public DateOnly? SentDate { get; set; }
}
