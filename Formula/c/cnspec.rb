class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.35.2.tar.gz"
  sha256 "c298dedff8120227128d15d5c4f534d26f254bc8a654e56c22972c069423cac5"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ab0d1b48421f232dbd522775e75b3c0fa3f785405ee6752221dffb434880201"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cd949e1c4fcd2f4911be11278878f547295433af62bb8ea659f2feaf8632765"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9d6f433e30e02b13db54b197170c5f27d82f501cf5bd575c4fe56c0f956f69c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f563943d07a8cafdf13ef6b54e6f542d83a3ce02ffe151aaa28cafeb0eed6e01"
    sha256 cellar: :any,                 x86_64_linux:  "32f073371632053742814a950585b1f4cfefed7272e563eec7b6c35c7c321b0c"
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
