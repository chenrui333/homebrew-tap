class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "844f9bc0520b7c7d0ff0d69e73f9faebf4c90cd187708d1327af8a73f5eb5df8"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "84183af25f29a919c5627208f57133fbad19e672fe5f71c3ba33c22f258725d0"
    sha256               arm64_sequoia: "c43cc820e895ebeaacf6cb236b3c4f2ba4339ffaca15152702f7b7fbdff795d7"
    sha256               arm64_sonoma:  "aa618420601e3bbbd0dbd078d472eb0a7d9642e6c5fa72e36c4d06060b09c701"
    sha256 cellar: :any, arm64_linux:   "c35151e36295db698d6289c7c93336425857e060beae7f15b40019e10f9d7cec"
    sha256 cellar: :any, x86_64_linux:  "b01b89f9226946b1065fddb121c7efee290dee10121047de5bcc9af5b4173022"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libssh2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "parallel", because: "both install a sem executable"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "crates/sem-cli")
  end

  test do
    system "git", "init"
    system "git", "config", "user.email", "test@example.com"
    system "git", "config", "user.name", "Test User"
    (testpath/"hello.py").write <<~PYTHON
      def greet():
          print("hello")
    PYTHON
    system "git", "add", "hello.py"
    system "git", "commit", "-m", "init"

    output = shell_output("#{bin}/sem diff --commit HEAD --format json")
    json = JSON.parse(output)
    assert_equal 1, json["changes"].length
    assert_equal "function", json["changes"][0]["entityType"]
    assert_equal "greet", json["changes"][0]["entityName"]
  end
end
