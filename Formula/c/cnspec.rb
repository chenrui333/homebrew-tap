class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v14.5.0.tar.gz"
  sha256 "159965f6a9c5d45ef26047c4e41a00ef08787e86d7d0fa64169d9d4a09629f69"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b99887147ae9adf36f69f31763f8d4c2c46ea3ef49a7384293620340b3744d89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10bfa64c6721a7b04810c027a72aa09b05f421afb35d47027b7abcc48c1dfa6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c834112e1453c5c40b4b5f239a63a7bac2292bc5fa66299a620d784f97ed406a"
    sha256 cellar: :any,                 x86_64_linux:  "f97e0c55628b372f39b219c986db787ba68535df175741ba7c60c2ecb8aeb6cf"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
