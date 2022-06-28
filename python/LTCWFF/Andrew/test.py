my_roster_list = ['tom brady', 'adrian peterson', 'antonio brown']
my_roster_list_proper = [x.title() for x in my_roster_list]
print(my_roster_list)
print(my_roster_list_proper)

my_roster_last_name = [full_name.split(
    ' ')[1].title() for full_name in my_roster_list]
print(my_roster_last_name)

pts_per_player = {
    'tom brady': 20.7, 'adrian peterson': 10.1, 'antonio brown': 18.5
}

pts_x2_per_upper_player = {
    name.title(): pts*2 for name, pts in pts_per_player.items()
}
print(pts_per_player)
print(pts_x2_per_upper_player)
print(sum([pts for _, pts in pts_per_player.items()]))


def rec_pts(yds, rec, tds):
    """
    this function takes number of receiving: yards, receptions and touchdown and returns fantasy points scored (ppr scoring)
    """
    print(yds*0.1 + rec*1 + tds*6)


rec_pts(110, 6, 1)
