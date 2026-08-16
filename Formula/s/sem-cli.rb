class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "06394f19a8ce6413d4f171f5a3c0b0583139b8fcb3720c3efd40615e76f3487a"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "cf9cdf7b0806513445c48e7c26a4b139ed57f38ae17eb7e8b9e2d54cb48a31c8"
    sha256               arm64_sequoia: "e3335ceaa4acd5716dfd2327827e5375f14708dff2b64bbe9d27bd76ee25c85b"
    sha256               arm64_sonoma:  "cd8a3b505a546d2875d08589906f5238eb056dfa949897894b5e58dbda672ddf"
    sha256 cellar: :any, arm64_linux:   "c94bbf3573f50fd05a73be3311c8ab7c515726fcd1609233be5bc4c3316509cf"
    sha256 cellar: :any, x86_64_linux:  "b5e7ae92b8501bbdd6c2a210fe65aed0f9b007950cd68f91f92400e1260dd526"
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
