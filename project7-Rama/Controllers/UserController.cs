using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using project7_Rama.DTO;
using project7_Rama.Models;
using project7_Rama.Services;

namespace project7_Rama.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly MyDbContext _db;
        private readonly TokenGenerator _tokenGenerator;
        public UserController(MyDbContext db, TokenGenerator tokenGenerator)
        {
            _db = db;
            _tokenGenerator = tokenGenerator;
        }
        [HttpPost("register")]
        public ActionResult Register([FromForm] UserDTO model)
        {
            if (model.Password != model.repeatePassword)
            {
                return BadRequest();
            }
            var existingUser = _db.Users.FirstOrDefault(x => x.Email == model.Email);
            if (existingUser != null)
            {
                return BadRequest("this email is already exist");
            }
            byte[] passwordHash, passwordSalt;
            PasswordHasher.CreatePasswordHash(model.Password, out passwordHash, out passwordSalt);
            
            User user = new User
            {
                
                FirstName = model.FirstName,
                LastName = model.LastName,
                Email = model.Email,
                PasswordHash = passwordHash,
                PasswordSalt = passwordSalt,
                UserType = "client"
            };
            
            _db.Users.Add(user);
            _db.SaveChanges();

            return Ok(user);
        }
        [HttpPost("login")]
        public IActionResult Login([FromForm] loginUserDTO model)
        {
            var user = _db.Users.FirstOrDefault(x => x.Email == model.Email);
            if (user == null || !PasswordHasher.VerifyPasswordHash(model.Password, user.PasswordHash, user.PasswordSalt))
            {
                return Unauthorized("Invalid username or password.");
            }
            var roles = _db.UserRoles.Where(r => r.UserId == user.UserId).Select(r => r.Role).ToList();
            var token = _tokenGenerator.GenerateToken(user.FirstName+" "+user.LastName, roles);
            // Generate a token or return a success response
            return Ok(new { Token = token });
        }
    }
}
