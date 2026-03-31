class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.3.0.tar.gz"
  sha256 "59a96d508af7c5cfd72c049de2feae1f67235c9bae40f5759c6a3e4015736423"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7ccf3d456f104962493c010d96ceab8577efa839451bf245a6198b75fcdd32e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f9986592a683fd38648db4cd09769a2bd85465525306a503e4c24b5bb69e48b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51f5ab84a04dbafbcc4f07f1b21c7b7a3897638d0f4f1353907af1c1a8e7f018"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "489a452fd86e912baf6ebc8c14fdb2385d8180808a231a450c8f8524ad575a21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddb5331715ec78ef40c1c992db2c3b286e557abe5d8c6035cfbb7f558f607819"
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
