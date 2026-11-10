class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "6222e5f74b6694c16154f2585b8bd9964010befabf1ee916d55af8a459b31dfe"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a13d973f5269bc9bef05c1cbab90e6199f73854368b204f07793915ee05bc234"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5482e5a6b99d592a19c03e677c02f3f84a35a32d438d6b2e7103f7e5df22a2d0"
    sha256 cellar: :any,                 arm64_linux:   "c186f3cb0daa9be08709b5b9ca82daab4c977910cbf9746f8d53f0477e6f47c7"
    sha256 cellar: :any,                 x86_64_linux:  "1ebb95ad9a5c4d87b5dc2ce66519ec1c1810552e877c4c42bc6badaf6993cbcd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libssh2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "parallel", because: "both install a sem executable"

  deny_network_access!

  def fetch
    cd "crates" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

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
