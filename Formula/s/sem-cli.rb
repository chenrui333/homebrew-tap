class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "02a4a9e52951300843d4fd9dcd48589d571f08268e1fd14f3e9e848dacf7321f"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d744066f5945d6909f16a756ff1cabb849883a3a65ad24a697e1af754333eac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa8a07baceedf6195550d859032276d40c09a84bbdf764896cde20dd38743e57"
    sha256 cellar: :any,                 arm64_linux:   "a86a3634ff809e5c0e018320f5a68a6d9a55f6a2975e552b124c0a8af80731d8"
    sha256 cellar: :any,                 x86_64_linux:  "9dca795ba59a6fa9a748fc2c084d428d1047afec97e3dbd8511a1a7011b85381"
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
