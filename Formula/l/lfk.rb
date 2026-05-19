class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "d3d8b4f122bbf977642609ebbda8d052fb85e9f2c5cf79461372717205990d53"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc4d8b3f95abab59a51e775c76f057312d4d92f2b6cefb28841699e4e83d9a8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc4d8b3f95abab59a51e775c76f057312d4d92f2b6cefb28841699e4e83d9a8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc4d8b3f95abab59a51e775c76f057312d4d92f2b6cefb28841699e4e83d9a8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a35791e95188413a540b40e9da8c224977c5aa625ee97d8406988047cf95ab97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74d25fd4164a19e0beb05f6cd17ce7ce4d56954c0adbbd9b4a81edb986112260"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/janosmiko/lfk/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"lfk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lfk --version 2>&1")
    assert_match "#compdef lfk", shell_output("#{bin}/lfk completion zsh")
  end
end
