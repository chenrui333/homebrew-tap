class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v12.22.0.tar.gz"
  sha256 "ac28f8c0ed8773f9b5bf856b9ad701c744722ff705037ced4bc703446d37a732"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2cbb586958720005e5cc01d67cbe08378adaf46a9d9a9859a46c89d07654449"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1663f71d67fdf5eeeffb7884283218f9699b1625675e1f18726753b08576b678"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52f85cb0883f1f99ef85ad0d18b3583c4eac5f123461e2a49545e3cf80d7844d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b1cbf88db96c03b4c8c0eaf338c119a36994de61dcb70d1d0f3615bfc1823c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68733147d7eeab0d507a21e07ff61546e87fba77f16d53a5d3064fde0291afe8"
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
