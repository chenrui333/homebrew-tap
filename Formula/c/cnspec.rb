class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.29.1.tar.gz"
  sha256 "1792a84579c71460ee7359a7cf7a7b4462a197055ddad5bd28b94a59455812a7"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "249a4832048b20455366332f67a37c4bf368018c465da189f56351e278e645b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51549ab23d020838650e36e1f5a5ea7060d7162aad1e095bb3cb46cae2dc8759"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "074c86b18d36dbf98a80391c4c79bbedce662ba558d039cb8bda9dfa503404d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "513cdd0fa029c375a1364a26d603b62b6107ac2275adda8a5ab93a2a2f0e1159"
    sha256 cellar: :any,                 x86_64_linux:  "a80497722d40fca3a4299620ab61a9c340c9943cd05c220091fc65071d5e8f3f"
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
