class Horusec < Formula
  desc "Improve identification of vulnerabilities in your project with just one command"
  homepage "https://github.com/ZupIT/horusec"
  url "https://github.com/ZupIT/horusec/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "3824728b7b29656416aaf23ff8cbda62fe9921d2fb982c19f8cda4f0df933592"
  license "Apache-2.0"
  head "https://github.com/ZupIT/horusec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1693b4fabee9526e7871b41744711ef25f89be6bacfc98f5421c25bf91ac74e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c17573ecb0ad13fb69f1fd221ae0829439f65c4879501ba3a6ad83ef365ccc1"
    sha256 cellar: :any_skip_relocation, ventura:       "abdd3013a485c880e375bca54fa7a84eb22344466f2a79f137a21ca1486b3250"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39ffeb3c55db70f3be676e76c25378ea20ade68db6bb13942b5184de1698dcc8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ZupIT/horusec/cmd/app/version.Version=#{version}
      -X github.com/ZupIT/horusec/cmd/app/version.Commit=#{tap.user}
      -X github.com/ZupIT/horusec/cmd/app/version.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/app"

    generate_completions_from_executable(bin/"horusec", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/horusec version 2>&1")
    system bin/"horusec", "generate"
    assert_match "\"horusecCliCertInsecureSkipVerify\": false", (testpath/"horusec-config.json").read
  end
end
