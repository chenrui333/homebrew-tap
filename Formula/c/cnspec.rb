class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v14.0.0-pre.1.tar.gz"
  sha256 "33c49149a41cb5fd8df70888f07f2b785121a2437247f41276deac6877ce6ecc"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "983d1ab7652294f4dc51b02880884ead99abfc525858235575aaccc5479eb446"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8fddd021415881d991272deb4838e6ae5d8ae600b500126950eeb111ad5363f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6363716092c83a036b29a5cc0706b0f9322b6f1e4ec2c304faedf1a9551f4d65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a145b679d87e10879bc5435d13d4b77a61875a4939281c5383f9000cfb206378"
    sha256 cellar: :any,                 x86_64_linux:  "f8ab844612cf9635350886067ae190e78300f9154d92bf061bd1943ce63d5664"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.mondoo.com/cnspec.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cnspec version")

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
