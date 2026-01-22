class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v12.19.2.tar.gz"
  sha256 "e36e4e6b38053e6d95048d9442214b4b4dbe4053eab8035389c56c11d6187fcb"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88e3ae33f30a9743686848cc2fb8ceb859d1d45a93ee5fdd45172d550b341805"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "541fdf4632b664b2ba15668e579f7f2a13645d82de020ff2ae134d8e534fd616"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43ef10c91327e9b557c61338706177d063b6009f3f6ebf352dd13e67ac61f4e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78ff3ab93a8171240185b2cf89213532904b4a72b3cf4acb8778b2b35653f107"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1fbe031c612669e2786a99793ed80c4f89d4640174fefc7e3e63abeabad51d9"
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
