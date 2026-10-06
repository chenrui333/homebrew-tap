class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.30.0.tar.gz"
  sha256 "3a589b01d02c771afdb2ebf63bdca0fcfba6d0f3be13892a745e617c59e860c0"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8244df20c0ec7de012d7fe42fdabc36c9fc462ed637a0aef363e58cfa97c99e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1daa109f08c17ccf6938bf84adfb3a96035f2e9a9cc2b24111161d30b8bbbd96"
    sha256 cellar: :any,                 arm64_linux:   "ed78106df83305ce82570165c14710c4ad4135db8275c66827206c875c347965"
    sha256 cellar: :any,                 x86_64_linux:  "ae4fb958aacb6a44f084136e47023238d30774cd6473a2d9513b06d429276722"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/purple --version 2>&1")

    (testpath/"ssh_config").write <<~EOS
      Host tap-test
        HostName 127.0.0.1
        User nobody
    EOS

    output = shell_output("#{bin}/purple --list --config #{testpath}/ssh_config")
    assert_match "tap-test", output
  end
end
