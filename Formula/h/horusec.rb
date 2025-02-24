class Horusec < Formula
  desc "Improve identification of vulnerabilities in your project with just one command"
  homepage "https://docs.horusec.io/docs/cli/overview/"
  url "https://github.com/ZupIT/horusec/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "3824728b7b29656416aaf23ff8cbda62fe9921d2fb982c19f8cda4f0df933592"
  license "Apache-2.0"
  head "https://github.com/ZupIT/horusec.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ZupIT/horusec/cmd/app/version.Version=#{version}
      -X github.com/ZupIT/horusec/cmd/app/version.Commit=#{tap.user}
      -X github.com/ZupIT/horusec/cmd/app/version.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/app"

    generate_completions_from_executable(bin/"horusec", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/horusec version 2>&1")
    system bin/"horusec", "generate"
    assert_match "\"horusecCliCertInsecureSkipVerify\": false", (testpath/"horusec-config.json").read
  end
end
