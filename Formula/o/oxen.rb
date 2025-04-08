class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.32.4.tar.gz"
  sha256 "09209a1caec61ae0d5ee82617732c64feb18fb282378204cd0ed043573e4647a"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9dc042972400e07d60a57755652563603f9202d7910498cfaa0b02e81750e47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ade893109c7caf07709b6a45504463884ea2ad4ece6e715a81770f2a44efb616"
    sha256 cellar: :any_skip_relocation, ventura:       "718ca3aa44a26f140b40e0c02c791506751000a819cc261a73ec2e999eae4e57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e83a0273dd4fe56b5478e8a857b7d342d54350e6f471053e765efd3e32fa437"
  end

  depends_on "cmake" => :build # for libz-ng-sys
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
