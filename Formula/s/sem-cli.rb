class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.3.10.tar.gz"
  sha256 "97fcceab5745204001526220f6e207925466e49489d3af4cc76b9219a59b5a97"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02eaf8eb9481db9ef41167fdedad2a41ed17372149300f076a287897f0d9191e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db1f2988265e088f0d4a00c4730c5468913216fd5421f61d8f215b2636a270e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd3459f8f9de46045087959953005ebeadbfc1da68ae1558dd0dc7b0454fbad8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45d08c78ffbe18ab4397f367aa07a49b7c096f1fcc310fb0eb593ef5f4e329ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd6259df2d96b4724eb6576edb28e2c5690f48049988ee76e7af5363f51c39f7"
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
