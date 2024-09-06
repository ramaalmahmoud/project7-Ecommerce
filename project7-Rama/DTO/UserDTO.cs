using System.ComponentModel.DataAnnotations;

namespace project7_Rama.DTO
{
    public class UserDTO
    {
        [Required]
        public string? FirstName { get; set; }

        public string? LastName { get; set; }
        [EmailAddress]
        public string? Email { get; set; }
        [Required]
        public string Password { get; set; }
        [Required]
        public string repeatePassword { get; set; }
    }
}
