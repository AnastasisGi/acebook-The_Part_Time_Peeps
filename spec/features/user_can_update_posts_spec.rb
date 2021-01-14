describe 'updating posts' do
  let(:original_post) { 'Updating this post' }
  let(:updated_post) { 'This is an updated post message' }
  let!(:post_writer) { User.create(email: 'update@example.com', password: 'testtest') }
  let!(:wall_owner) { User.create(email: 'owner@example.com', password: 'testtest') }
  let!(:post) do
    Post.create(message: original_post, user_id: post_writer.id, wall_id: wall_owner.id)
  end

  before do
    visit '/users/sign_in'
    fill_in 'Email', with: post_writer.email
    fill_in 'Password', with: post_writer.password
    click_button 'Log in'
  end

  it 'displays an update button' do
    visit "/#{wall_owner.id}"
    expect(page).to have_button 'Update'
  end

  it 'can update a post' do
    visit "/#{wall_owner.id}"
    click_button 'Update'
    expect(page).to have_current_path "/posts/#{post.id}/edit", ignore_query: true
    fill_in 'Message', with: updated_post
    click_button 'Update'
    expect(page).to have_current_path "/#{wall_owner.id}", ignore_query: true
    expect(page).not_to have_content(original_post)
    expect(page).to have_content(updated_post)
  end
end
