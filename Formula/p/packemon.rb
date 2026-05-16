class Packemon < Formula
  desc "Terminal tool for generating and monitoring packets"
  homepage "https://github.com/ddddddO/packemon"
  url "https://github.com/ddddddO/packemon/archive/refs/tags/v1.8.22.tar.gz"
  sha256 "30cbd7805566920895ec3130e40c9960081ec35a8e90bd9721b8a6a6f9e16a0e"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/packemon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04be962fda2bd8843b671989e9e322ea492d1c33a20b7a685e8b6646bd959f12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f13ae4d35fd8fdfe469fc1248719c1aeb6b74ebc16a92a462d7ef6aa8b06cba7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02bf6508a0256022fea0c9bffedebde358b7dd11efe35dff117326c57ba889e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5fc178bcf7febd9eef491ec3439fee64f789d9057d59b3930298677ea17a558"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "517ad603d92b7b894c1a72a51923fba7fd4eca60e113da7b5b1ab502e540848a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=brew"
    system "go", "build", *std_go_args(ldflags:), "./cmd/packemon"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/packemon version")

    interfaces = JSON.parse(shell_output("#{bin}/packemon interfaces --json"))
    assert_kind_of Array, interfaces
    refute_empty interfaces
    assert_kind_of Hash, interfaces.first
    assert interfaces.first.key?("InterfaceName")
  end
end
