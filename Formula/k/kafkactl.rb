class Kafkactl < Formula
  desc "Firefox Reader View as a command-line tool"
  homepage "https://deviceinsight.github.io/kafkactl/"
  url "https://github.com/deviceinsight/kafkactl/archive/refs/tags/v5.5.0.tar.gz"
  sha256 "d8611f0ac3c091216e5cfff21ae1cc6de2fe0d72bdc0f0a47b7a1b0507a6b157"
  license "Apache-2.0"
  head "https://github.com/deviceinsight/kafkactl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60871e4eb06da13a2408c3d285cdabc2c8c16499dd99131d00cdbaff16b79903"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec5bc541a19d46f8d8dc66abe9f1ad795001b6d5a17a3c1ec3472646bc6b62ab"
    sha256 cellar: :any_skip_relocation, ventura:       "e402c40ab065b485fbaf294d32d26393bff805bb14631bc70326da9c90e63d89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7a8b2bb1523f85ccd70b9a184cf0b9670a4130fdeb2de45d88679fc3f7f065f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/deviceinsight/kafkactl/v5/cmd.Version=#{version}
      -X github.com/deviceinsight/kafkactl/v5/cmd.GitCommit=#{tap.user}
      -X github.com/deviceinsight/kafkactl/v5/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kafkactl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kafkactl version")

    output = shell_output("#{bin}/kafkactl produce greetings 2>&1", 1)
    assert_match "Failed to open Kafka producer", output
  end
end
