//
//  DBCell.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/5/27.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "DBCell.h"
#import "Person.h"
#import "Card.h"

@implementation DBCell

- (void)awakeFromNib
{
    
}

- (void)showModel:(Person *)person
{
    self.nameLabel.text = [NSString stringWithFormat:@"%@",person.name];
    Card *card = person.card;
    self.cardLabel.text = [NSString stringWithFormat:@"%@",card.no];
    self.genderLabel.text = [NSString stringWithFormat:@"%@",person.gender];
    self.ageLabel.text = [NSString stringWithFormat:@"%@",person.age];
    self.idLabel.text = [NSString stringWithFormat:@"%@",person.id];
}

@end
