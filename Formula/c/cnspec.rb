class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.5.1.tar.gz"
  sha256 "0986bed57312a726a529b20f59ff47dfbe7cdd06324d58baf657e50cd260ef76"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9778faabc90b01e2b931dff909b1d26c76efe8817b92f503cc93f03947ea6a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "292d8643535050f84543e8b6cdea44bc0bf3d9d835f254070ea6fc886a78fc88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2988870879449e52de2041c46ade90c00f1f4bf0f9a15981ba08f13dc253e55b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a648d70f4bc8a9c9df0e227febff327c0debf67657a49b2f40f91208e203a241"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "641ee3efaf63f1212e9c6944af4bd6e8c069b4e4e7590a131ab0114a53abf6df"
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
