class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.20.1.tar.gz"
  sha256 "c7d573452d34e6b894cf1cca035a064371173f78f00ae2524a94e1dad8d98740"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfb6eae11edaa721aaa58b604d187fb163486109d491f3dd469a696d8da59989"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93ebae3b523d94d8bc7e1a89103413e3d858100fe63e3b9de7f375ae9575ad67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77ae6da8fc0b297fceabcb4795b911da6dee15cd405dcbf06fff1927c9690e0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e261ad545b1cccef8b6a85c639bc4d8dc88262e28064b530ae80e790cf1eb560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e4007637fa2db08f6af69be7d3a48d1858d6a0eb9cb57aa68ebffd4298b66a0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.mondoo.com/cnquery/v#{version.major}.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", shell_parameter_format: :cobra)
  end

  test do
    system bin/"cnspec", "version"

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
