class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.18.1.tar.gz"
  sha256 "e6ce4ccf168b9fccb1ee18ff0f490ba84e3cbac102e93d0116ce910aa767621c"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1404eb435b16ee11bf4f0642736ecec7f41fe4606a27139cc972bac9b1fc5ad0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86e81cf446e97e674cd1690050ec1f544f9480479117c05577741064aeba82fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66812b8f90c707f921a8d760fd600ae3d645f0e481938d49ef8e15c320fe4053"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94f871d2e269f51ad49afc85d070c402c8f8b675920d704fa1ba0363335d9d9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88f70d84dab09d751f15ffd193bbff8c326269807a3631fe83e5328b1661a09f"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/purple --version 2>&1")
  end
end
