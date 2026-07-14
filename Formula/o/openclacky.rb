class Openclacky < Formula
  desc "Token-efficient open-source AI Agent with skill system and IM integrations"
  homepage "https://github.com/clacky-ai/openclacky"
  url "https://github.com/clacky-ai/openclacky/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "2492141be0757167bf919fa04b7b29d29149cc6532291c2bd8c8192862a8e1f4"
  license "MIT"
  head "https://github.com/clacky-ai/openclacky.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc7901ed65e3db77d3321cf8e8228d147aea5eb638afbb1eaf59c1e1f919b320"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc7901ed65e3db77d3321cf8e8228d147aea5eb638afbb1eaf59c1e1f919b320"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc7901ed65e3db77d3321cf8e8228d147aea5eb638afbb1eaf59c1e1f919b320"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "111acabafe49ac65798dd1290a274503c7e9842055e766f559e8eeb6316ff047"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "111acabafe49ac65798dd1290a274503c7e9842055e766f559e8eeb6316ff047"
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
