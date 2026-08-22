class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "5c890d52947d95b73178ead5341eadb585d6fdc2ef9795fbe010d5a7d477f77e"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "c22858f37716a8d31475f4acd6548e50fe3aee90b470209ff7b1c1a9254edb4d"
    sha256               arm64_sequoia: "f1dda561a7e3d61feb26b40446010050cf3ca62ed53ae910d04ae3d01c7ae9c2"
    sha256               arm64_sonoma:  "a1018968deff5e301c9a7488bc12c9e63e7041c1558f586b9c7d9ddbe018b4f8"
    sha256 cellar: :any, arm64_linux:   "95f83e25b14e75dedac5c88f65ddadaf21d8d9f002af772392946d579a58c3b5"
    sha256 cellar: :any, x86_64_linux:  "335f3acc03c506250da0fac6e94a3744624c8cbe6c44596f3ce1078efa985f1b"
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
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "crates/sem-cli"), "--no-default-features"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sem --version")

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
