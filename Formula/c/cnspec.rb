class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.34.0.tar.gz"
  sha256 "2ea7ac111a264b1b524a19300d27b0f6c570eb3794c962e82f4889f4fa5c5985"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dec46bb045c7ea62929d86f12036c2fcfd888c1aefc3888dc3706fda8acc60be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "661cf33501c6e02b82e5b258dd1cb4f5d837c3824f5f2fa77a17461fae284f84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4ca041bd52467a4d9ac7a22062764ca05df1bbee0760d5418680206439837d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca3de26aaed68cbb95be830f72fa6cad548043598b752ee845ce74ad947d4e8f"
    sha256 cellar: :any,                 x86_64_linux:  "8c8a229dc57ba8967314f8c7221294c868dad174fd510c1521fa9c32179bede7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.mondoo.com/cnspec/v#{version.major}.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cnspec version")

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
