class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "75b44ce3513afba862c1456e8c00314a9c2c00e927d20171bf895c240edcd0ea"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "778fef049b5366fc8d9c0da39ef88b16aad66a6116f4053ceb4e7d5344fbf527"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72c25be8e1e2444d2985a3a4b8e996dfadbcd39c9bd675c476bd1769975965be"
    sha256 cellar: :any_skip_relocation, ventura:       "ef0751a062f793b21afbc61da555f048a3db21c427661be7c5026f49bf67ce3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f19ac8d78f4dcd577e19b53a9ac00dc40f6b6f84f83f65c973562ee2ce0538eb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end
