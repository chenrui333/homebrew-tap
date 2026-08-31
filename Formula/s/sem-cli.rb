class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "9cf030ad886a106aa26ba571e29d6b7de6b9ac37957a2f4ecea2989b91b56fb5"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "634b0f223b0d40da5d8b5d16a37144f4ea7f21cfa2975c275107e688ec25d04e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41a9e3a3bc03ab42984eb0757c2dd4382e7e7e7753f0eaabc01aa5748172d1c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e7d0a9512e89a58ba1aeaa4bd8ea259fe3e1b02b6318e3d22e9c7e9abb8d1f4"
    sha256 cellar: :any,                 arm64_linux:   "6a93aeb63bd53158ff316cd9bd24a70df2f79354cd5c44f4348632da2c69127e"
    sha256 cellar: :any,                 x86_64_linux:  "a69d003490eab4122bca96647c85625129b702a93611173983533843e8969ce1"
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
