class Openclacky < Formula
  desc "Token-efficient open-source AI Agent with skill system and IM integrations"
  homepage "https://github.com/clacky-ai/openclacky"
  url "https://github.com/clacky-ai/openclacky/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "d2b638a14b9d1b6873681246bf05012f890286d494bc799f0bc1fbd04020a9f2"
  license "MIT"
  head "https://github.com/clacky-ai/openclacky.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c0b6c11a1e8952fab2689a8b411ab99eef69920735dc724079b4c71c6b0f5af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c0b6c11a1e8952fab2689a8b411ab99eef69920735dc724079b4c71c6b0f5af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c0b6c11a1e8952fab2689a8b411ab99eef69920735dc724079b4c71c6b0f5af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0fb4468aae69e9f4135f2122116371eb7b4f3850492f6f2ad3d87428a62bcc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0fb4468aae69e9f4135f2122116371eb7b4f3850492f6f2ad3d87428a62bcc9"
  end

  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec

    system "git", "init"
    system "git", "add", "."
    system "gem", "build", "openclacky.gemspec"
    system "gem", "install", "--no-document", "openclacky-#{version}.gem"

    %w[clacky openclacky clarky].each do |cmd|
      (bin/cmd).write_env_script libexec/"bin"/cmd, GEM_HOME: ENV["GEM_HOME"]
    end
  end

  test do
    assert_match "agent", shell_output("#{bin}/clacky help")
    assert_match "Commands", shell_output("#{bin}/openclacky help")
  end
end
